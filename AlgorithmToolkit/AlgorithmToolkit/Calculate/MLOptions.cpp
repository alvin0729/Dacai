// MLOptions.cpp: implementation of the MLOptions class.
//
//////////////////////////////////////////////////////////////////////

#include "MLOptions.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////


MLOptions::MLOptions(Array<Array<int>*>* gameTypeOptionsLenArray,Array<int>* hadAllIndexArray,Array<int>* gallIndexArray,Array<int>* gallRangeArray,Array<PassMode*>* passModes,Array<double>* maxSps,Array<double>* minSps)
{
	gameTypeOptionsLen=0;
    if(gameTypeOptionsLenArray!=0)
    {
        this->gameTypeOptionsLen=new Array<int>();
        int len=gameTypeOptionsLenArray->GetLength();
        int* array=new int[len];
        for(int i=0;i<len;i++)
        {
            array[i]=(*(*gameTypeOptionsLenArray)[i])->GetLength();
        }
        gameTypeOptionsLen->Set(array,len);
    }
    this->gameTypeOptionsLenArray=gameTypeOptionsLenArray;
    this->hadAllIndexArray=hadAllIndexArray;
	this->gallIndexArray=gallIndexArray;
	this->gallRangeArray=gallRangeArray;
	this->passModes=passModes;
	this->maxSps=maxSps;
	this->minSps=minSps;
    
	Init();
}

/*
 MLOptions::MLOptions(Array<int>* gameTypeLenArray,Array<int>* hadAllIndexArray,Array<int>* gallIndexArray,Array<int>* gallRangeArray,Array<PassMode*>* passModes,Array<double>* maxSps,Array<double>* minSps)
 {
 gameTypeOptionsLenArray=0;
 this->gameTypeOptionsLen=gameTypeLenArray;
 this->hadAllIndexArray=hadAllIndexArray;
 this->gallIndexArray=gallIndexArray;
 this->gallRangeArray=gallRangeArray;
 this->passModes=passModes;
 this->maxSps=maxSps;
 this->minSps=minSps;
 
 Init();
 }
 */

MLOptions::~MLOptions()
{
	if(gameTypeOptionsLenArray!=0&&gameTypeOptionsLen!=0)
	{
	    delete gameTypeOptionsLen;
	}
    if(dragIndexArray!=0)
    {
        delete dragIndexArray;
        dragIndexArray=0;
    }
    
    if(dragTotalLenArray!=0)
    {
        delete dragTotalLenArray;
        dragTotalLenArray=0;
    }
    
    if(gallTotalLenArray!=0)
    {
        delete gallTotalLenArray;
        gallTotalLenArray=0;
    }
    
    if(bets!=0)
    {
        int len=bets->GetLength();
        Bet** betArray=bets->GetArray();
        for(int i=0;i<len;i++)
        {
            delete betArray[i];
        }
        
        delete bets;
        bets=0;
    }
}

void MLOptions::Init()
{
	int i=0;
	this->dragIndexArray=0;
	this->dragTotalLenArray=0;
	this->gallTotalLenArray=0;
	this->bets=0;
    this->hadAllIndexCode=0;
    
	this->isInvalidData=false;
	this->isAllSinglePassModes=true;
	this->isSingleTypeForField=true;
    
    if (passModes == 0 || passModes->GetLength() < 1)
    {
        this->isInvalidData = true;
        //message = "过关方式不正确";
        return;
    }
    else
    {
        int pmLen=passModes->GetLength();
        
        for( i=0;i<pmLen;i++)
        {
		    PassMode* passMode=*(*passModes)[i];
            if (passMode == 0)
			{
                this->isInvalidData  = true;
                //message = "过关方式不正确，包含空过关方式";
                return;
			}
            
            if (passMode->GetMode() > 1)
            {
                this->isAllSinglePassModes = false;
                this->complexPassModeList.Add(passMode);
            }
            else
            {
                this->singlePassModeList.Add(passMode);
            }
        }
    }
    int* diArray=0;
    if (this->gameTypeOptionsLen == 0)
    {
        this->isInvalidData  = true;
        //message = "无场次信息";
        return;
    }
    int flaLen=gameTypeOptionsLen->GetLength();
    int giLen=0;
    if(gallIndexArray!=0)
    {
        giLen=gallIndexArray->GetLength();
    }
    if (giLen < 1)
    {
        diArray = new int[flaLen];
        for ( i = 0; i < flaLen; i++)
        {
            diArray[i] = i;
        }
    }
    else
    {
        if (giLen > flaLen)
        {
            this->isInvalidData = true;
            //message = "胆数量过多";
            return;
        }
        
        int diLen=flaLen-giLen;
        diArray = new int[diLen];
        int p=0;
        for ( i = 0; i < flaLen; i++)
        {
            if ( gallIndexArray->IndexOf(i) == -1)
            {
                if (p >= diLen)
                {
                    this->isInvalidData = true;
                    //message = "胆信息有误";
                    return;
                }
                diArray[p++] = i;
            }
        }
    }
    
    this->dragIndexArray=new Array<int>();
    this->dragIndexArray->Set(diArray,flaLen-giLen);
    
    
    
    int* gtLArray = new int[giLen];
    int* dtlArray = new int[flaLen-giLen];
    int gIndex = 0, dIndex = 0;
    Array<int>** ftlArray=this->gameTypeOptionsLenArray->GetArray();
    int sum=0;
    for ( i = 0 ; i < flaLen; i++)
    {
        if((ftlArray[i])==0)
        {
            sum=0;
        }else
        {
            if(ftlArray[i]->GetLength()>1)
            {
                isSingleTypeForField=false;
            }
            sum=ftlArray[i]->Sum();
        }
        if (giLen==0||gallIndexArray->IndexOf(i) == -1)
        {
            dtlArray[dIndex++] = sum ;
        }
        else
        {
            gtLArray[gIndex++] = sum;
        }
    }
    this->dragTotalLenArray=new Array<int>();
    this->dragTotalLenArray->Set(dtlArray,dIndex);
    this->gallTotalLenArray=new Array<int>();
    this->gallTotalLenArray->Set(gtLArray,gIndex);
}


Array<Bet*>* MLOptions::GetBets()
{
    
	if(this->bets!=0)
	{
        return bets;
	}
    
	if(this->gameTypeOptionsLen->GetLength()>30)
	{
	    return 0;//最多支持30场
	}
    
	int c=this->GetMinBets();
    
	if(c>200000)
	{
	    return 0;//最多支持20万个组合过关方式
	}
    
    Dictionary<int,Bet*> dic;
    
    Dictionary<int, List<PassMode*>*> samePassModeDic;
    
	int pass=0;
	int passIndex=0;
	int rangeIndex=0;
    
	int gallCount=0;
	int grLen=0;
	if(gallRangeArray!=0)
	{
        grLen=gallRangeArray->GetLength();
	}
    
    FillSamePassMode(&samePassModeDic);
    int itemLen=samePassModeDic.GetDataLen();
    int* keys=new int[itemLen];
    samePassModeDic.GetKeys(keys,itemLen);
    
    for (passIndex=0;passIndex<itemLen;passIndex++)
    {
        pass=keys[passIndex];
        int* ncIndexArray=new int[pass];
        if(grLen>0)
        {
            for(rangeIndex=0;rangeIndex<grLen;rangeIndex++)
            {
                gallCount=*(*gallRangeArray)[rangeIndex];
                if (gallCount > pass)
                {
                    continue;
                }
                GetBetsByGall(&dic,&samePassModeDic,gallCount,pass,ncIndexArray);
            }
        }else
        {
            GetBetsByGall(&dic,&samePassModeDic,0,pass,ncIndexArray);
        }
        delete (*samePassModeDic[pass]);
        delete[] ncIndexArray;
    }
    delete[] keys;
    
    int dicLen=dic.GetDataLen();
    Bet** betArray=new Bet*[dicLen];
    dicLen=dic.GetValues(betArray,dicLen);
    Array<Bet*>* reArray= new Array<Bet*>();
    reArray->Set(betArray,dicLen);
    this->bets=reArray;
    return reArray;
}

bool MLOptions::IsAllSinglePassModes()
{
    return this->isAllSinglePassModes;
}

bool MLOptions::IsAllSingleTypeForField()
{
    return this->isSingleTypeForField;
}

bool MLOptions::IsInvalidData()
{
    return this->isInvalidData;
}


Array<int>* MLOptions::GetGameTypeOptionsLen()
{
    return this->gameTypeOptionsLen;
}

Array<int>* MLOptions::GetHadAllIndexArray()
{
    return this->hadAllIndexArray;
}

Array<int>* MLOptions::GetGallIndexArray()
{
    return this->gallIndexArray;
}

Array<int>* MLOptions::GetGallRangeArray()
{
    return this->gallRangeArray;
}

Array<PassMode*>* MLOptions::GetPassModes()
{
    return passModes;
}

Array<double>* MLOptions::GetMaxSps()
{
    return maxSps;
}

Array<double>* MLOptions::GetMinSps()
{
    return minSps;
}

//拖索引数组
Array<int>* MLOptions::GetDragIndexArray()
{
    return this->dragIndexArray;
}

//
Array<int>* MLOptions::GetGallTotalLenArray()
{
    return this->gallTotalLenArray;
}

//
Array<int>* MLOptions::GetDragTotalLenArray()
{
    return this->dragTotalLenArray;
}

//多过关方式集合体
List<PassMode*>* MLOptions::GetComplexPassModeList()
{
    return &this->complexPassModeList;
}

//单过关方式集合体
List<PassMode*>* MLOptions::GetSinglePassModeList()
{
    return &this->singlePassModeList;
}


Int64 MLOptions::GetHadAllIndexCode()
{
    if(this->hadAllIndexArray==0)
    {
        return 0;
    }
    if(this->hadAllIndexCode>0)
    {
        return hadAllIndexCode;
    }
    hadAllIndexCode=0;
    int haiLen=this->hadAllIndexArray->GetLength();
    int* haiArray=this->hadAllIndexArray->GetArray();
    for(int i=0;i<haiLen;i++)
    {
        hadAllIndexCode|=1<<haiArray[i];
    }
    return hadAllIndexCode;
}

void MLOptions::GetBetsForSubPass(Dictionary<int,Bet*>* dic,int* indexArray,int iaLen,Array<PassMode*>* passModes)
{
    int pmLen=passModes->GetLength();
    PassMode** pmArray=passModes->GetArray();
    unsigned char* iArray=0;
    unsigned char* betIndexArray=0;
    int innerLen=0;
    Array<unsigned char>* innerArray=0;
    int n=0,m=0;
    bool find=false;
    int* gameTypeLenArray=this->gameTypeOptionsLen->GetArray();
    int code=0;
    int repeat=0;
    for(int i=0;i<pmLen;i++)
    {
        PassMode* passMode=pmArray[i];
        Array<Array<unsigned char>*>* indexes=passMode->GetIndexes();
        int iLen=indexes->GetLength();
        for(int j=0;j<iLen;j++)
        {
            
            code=0;
            innerArray=(*(*indexes)[j]);
            innerLen=innerArray->GetLength();
            betIndexArray=new unsigned char[innerLen];
            iArray=innerArray->GetArray();
            
            for( n=0;n<innerLen;n++)
            {
                betIndexArray[n]=indexArray[iArray[n]];
                code|=1<<betIndexArray[n];
            }
            Bet** node=(*dic)[code];
            Bet* bet=0;
            if(node!=0)
            {
                bet=*node;
            }
            if(bet==0)
            {
                bet=new Bet();
                bet->IndexArray=betIndexArray;
                bet->Repeat=0;
                bet->Length=innerLen;
                dic->Add(code,bet);
            }
            repeat=1;
            for(n=0;n<iaLen;n++)
            {
                find=false;
                for(m=0;m<innerLen;m++)
                {
                    if(n==iArray[m])
                    {
                        find=true;
                        break;
                    }
                }
                if(!find)
                {
                    repeat*=gameTypeLenArray[indexArray[n]];
                }
            }
            bet->Repeat+=repeat;
        }
    }
}

int MLOptions::GetMinBets()
{
    Array<int>* gallOptionLenArray=0;
    int len=0;
    if(this->gallIndexArray!=0)
    {
        len=gallIndexArray->GetLength();
        int* array=new int[len];
        gallOptionLenArray=new Array<int>();
        gallOptionLenArray->Set(array,len);
        for(int i=0;i<len;i++)
        {
            array[i]=1;
        }
        
    }
    
    Array<int>* dragOptionLenArray=0;
    len=0;
    if(this->dragIndexArray!=0)
    {
        len=dragIndexArray->GetLength();
        int* array=new int[len];
        dragOptionLenArray=new Array<int>();
        dragOptionLenArray->Set(array,len);
        for(int i=0;i<len;i++)
        {
            array[i]=1;
        }
    }
    
    
    int c=BetCountor::Calculate(this->passModes,gallOptionLenArray,dragOptionLenArray,this->gallRangeArray);
    if(gallOptionLenArray!=0)
    {
		delete gallOptionLenArray;
    }
    if(dragOptionLenArray!=0)
    {
		delete dragOptionLenArray;
    }
    return c;
}


void MLOptions::FillSamePassMode(Dictionary<int, List<PassMode*>*>* dic)
{
    int pmLen=passModes->GetLength();
    int pass=0;
    
    for (int i = 0; i < pmLen; i++)
    {
        pass=(*(*passModes)[i])->GetPass();
        List<PassMode*>** pList=(*dic)[pass];
        if (pList!=0)
        {
            (*pList)->Add(*(*passModes)[i]);
        }
        else
        {
            List<PassMode*>* newList = new List<PassMode*>();
            newList->Add(*(*passModes)[i]);
            dic->Add(pass, newList);
        }
    }
}


void MLOptions::GetBetsByGall(Dictionary<int,Bet*>* dic,Dictionary<int, List<PassMode*>*>* samePassModeDic,int gallCount,int pass, int* ncIndexArray)
{
    int giaLen=0,diaLen=0;
    Array<Array<unsigned char>*>* gallIndexesArray = 0;
    if (gallCount > 0)
    {
        gallIndexesArray = Combination::GetIndexes((unsigned char)gallIndexArray->GetLength(), (unsigned char)gallCount);
        giaLen=gallIndexesArray->GetLength();
    }
    
    
    Array<Array<unsigned char>*>* dragIndexesArray = 0;
    
    int fetchCount=pass - gallCount;
    
    if (fetchCount>0)
    {
        dragIndexesArray = Combination::GetIndexes((unsigned char)dragIndexArray->GetLength(), (unsigned char)(pass - gallCount));
        diaLen=dragIndexesArray->GetLength();
    }
    
    if(giaLen==0&&diaLen==0)
    {
        return;
    }
    
    unsigned char* byteArray=0;
    int* intArray=0;
    Array<unsigned char>* gallIndexes=0;
    Array<unsigned char>* dragIndexes=0;
    int diLen=0,giLen=0,i=0;
    
    Array<PassMode*>* passModeArray=(*(*samePassModeDic)[pass])->ToArray();
    
    if(giaLen>0)
    {
        
        for(int giIndex=0;giIndex<giaLen;giIndex++)
        {
            gallIndexes=*(*gallIndexesArray)[giIndex];
            giLen=gallIndexes->GetLength();
            byteArray=gallIndexes->GetArray();
            intArray=gallIndexArray->GetArray();
            for (int n = 0; n < giLen; n++)
            {
                ncIndexArray[n] = intArray[byteArray[n]];
            }
            if(giLen<pass)
            {
                for ( i = 0; i < diaLen; i++)
                {
                    int c = gallCount;
                    dragIndexes=*(*dragIndexesArray)[i];
                    diLen=dragIndexes->GetLength();
                    byteArray=dragIndexes->GetArray();
                    intArray=dragIndexArray->GetArray();
                    for (int n = 0; n < diLen; n++)
                    {
                        ncIndexArray[c++] = intArray[byteArray[n]];
                    }
                    
                    GetBetsForSubPass(dic,ncIndexArray,pass, passModeArray);
                }
            }else{
                GetBetsForSubPass(dic,ncIndexArray,pass, passModeArray);
            }
            delete gallIndexes;
        }
        
        
        delete gallIndexesArray;
        
        for( i = 0; i < diaLen; i++)
        {
            delete *(*dragIndexesArray)[i];
        }
        delete dragIndexesArray;
    }
    else
    {
        for ( i = 0; i < diaLen; i++)
        {
            dragIndexes=*(*dragIndexesArray)[i];
            diLen=dragIndexes->GetLength();
            byteArray=dragIndexes->GetArray();
            intArray=dragIndexArray->GetArray();
            for (int n = 0; n < diLen; n++)
            {
                ncIndexArray[n] = intArray[byteArray[n]];
            }
            
            GetBetsForSubPass(dic,ncIndexArray,pass, passModeArray);
            delete *(*dragIndexesArray)[i];
        }
        delete dragIndexesArray;
    }
    delete passModeArray;
}


Array<Array<int>*>* MLOptions::GetGameTypeOptionsLenArray()
{
    return this->gameTypeOptionsLenArray;
}
