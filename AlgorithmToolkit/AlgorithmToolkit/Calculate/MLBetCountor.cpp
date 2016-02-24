// MLBetCountor.cpp: implementation of the MLBetCountor class.
//
//////////////////////////////////////////////////////////////////////

#include "MLBetCountor.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

MLBetCountor::MLBetCountor(Array<PassMode*>* passModes,Array<Array<int>*>* fieldLenArray,Array<int>* gallIndexArray,Array<int>* gallRangeArray)
{
    /*
     this->passModes=passModes;
     this->fieldLenArray=fieldLenArray;
     this->gallIndexArray=gallIndexArray;
     this->gallRangeArray=gallRangeArray;
     this->isAllSinglePassModes=true;
     this->isSingleTypeForField=true;
     this->isInvalidData=false;
     Init();*/
    isSelfCreateInfos=true;
    this->mlInfos=new MLOptions(fieldLenArray,0,gallIndexArray,gallRangeArray,passModes,0,0);
    
}


MLBetCountor::MLBetCountor(MLOptions* mlInfos)
{
    isSelfCreateInfos=false;
    this->mlInfos=mlInfos;
}


MLBetCountor::~MLBetCountor()
{
    
    if(isSelfCreateInfos)
    {
        delete mlInfos;
    }
}
/*
 void MLBetCountor::Init()
 {
 int i=0;
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
 if (this->fieldLenArray == 0)
 {
 this->isInvalidData  = true;
 //message = "无场次信息";
 return;
 }
 int flaLen=fieldLenArray->GetLength();
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
 
 this->drageIndexArray=new Array<int>();
 this->drageIndexArray->Set(diArray,flaLen-giLen);
 
 
 int innerSum=0;
 int* gtLArray = new int[giLen];
 int* dtlArray = new int[flaLen-giLen];
 int gIndex = 0, dIndex = 0,flaInnerLen=0;
 Array<int>* flaInnerArray=0;
 for ( i = 0 ; i < flaLen; i++)
 {
 flaInnerArray=*(*fieldLenArray)[i];
 flaInnerLen=flaInnerArray->GetLength();
 if (flaInnerLen< 1)
 {
 this->isInvalidData = true;
 //message = "包含无选项场次";
 return;
 }
 if (flaInnerLen > 1)
 {
 this->isSingleTypeForField = false;
 }
 
 innerSum = flaInnerArray->Sum();
 if (gallIndexArray==0||gallIndexArray->IndexOf(i) == -1)
 {
 dtlArray[dIndex++] = innerSum;
 }
 else
 {
 gtLArray[gIndex++] = innerSum;
 }
 }
 this->dragTotalLenArray=new Array<int>();
 this->dragTotalLenArray->Set(dtlArray,dIndex);
 this->gallTotalLenArray=new Array<int>();
 this->gallTotalLenArray->Set(gtLArray,gIndex);
 }
 */

Int64 MLBetCountor::Calculate()
{
    
    if (this->mlInfos->IsInvalidData())
    {
        return -1;
    }
    
    
    //加速计算
    if (this->mlInfos->IsAllSinglePassModes() || this->mlInfos->IsAllSingleTypeForField())
    {
        return BetCountor::Calculate(mlInfos->GetPassModes(), mlInfos->GetGallTotalLenArray(), mlInfos->GetDragTotalLenArray(), mlInfos->GetGallRangeArray());
    }
    
    Array<PassMode*>* complexPassModes=mlInfos->GetComplexPassModeList()->ToArray();
    Int64 count = BetCountor::Calculate(complexPassModes, mlInfos->GetGallTotalLenArray(), mlInfos->GetDragTotalLenArray(), mlInfos->GetGallRangeArray());
    
    if (count > MLBetCountorNoCalculateNumber)
    {
        // message = "计算值太大";
        return -1;
    }
    
    Int64 complexCount = CalculateComplex();
    
    Array<PassMode*>* singlePassModes=mlInfos->GetSinglePassModeList()->ToArray();
    Int64 singleCount = BetCountor::Calculate(singlePassModes, mlInfos->GetGallTotalLenArray(), mlInfos->GetDragTotalLenArray(), mlInfos->GetGallRangeArray());
    
    return complexCount + singleCount;
    
}


Int64 MLBetCountor::CalculateComplex()
{
    List<PassMode*> complexPassModeList=*mlInfos->GetComplexPassModeList();
    Array<int>* gallRangeArray=mlInfos->GetGallRangeArray();
    Array<int>* gallIndexArray=mlInfos->GetGallIndexArray();
    Array<int>* drageIndexArray=mlInfos->GetDragIndexArray();
    
    Dictionary<int, List<PassMode*>*> samePassModeDic;
    
    int pass=0;
    int passIndex=0;
    int rangeIndex=0;
    int giIndex = 0;
    int gallCount=0;
    int giLen=0;
    int diLen=0;
    int grLen=0;
    int diaLen=0;
    int giaLen=0;
    
    if(gallRangeArray!=0)
    {
        grLen=gallRangeArray->GetLength();
    }
    int i=0;
    
    this->FillSamePassMode(&complexPassModeList,&samePassModeDic);
    Int64 result = 0;
    
    int itemLen=samePassModeDic.GetDataLen();
    int* keys=new int[itemLen];
    samePassModeDic.GetKeys(keys,itemLen);
    
    for (passIndex=0; passIndex<itemLen; passIndex++)
    {
        pass=keys[passIndex];
        int* ncIndexArray=new int[pass];
        if(grLen>0)
        {
            for(rangeIndex=0; rangeIndex<grLen; rangeIndex++)
            {
                
                gallCount=*(*gallRangeArray)[rangeIndex];
                if (gallCount > pass)
                {
                    continue;
                }
                
                Array<Array<unsigned char>*>* gallIndexesArray = 0;
                if (gallCount > 0)
                {
                    gallIndexesArray = Combination::GetIndexes((unsigned char)gallIndexArray->GetLength(), (unsigned char)gallCount);
                }
                else
                {
                    gallIndexesArray = new  Array<Array<unsigned char>*>(1);
                }
                
                Array<Array<unsigned char>*>* dragIndexesArray = 0;
                
                if (pass > gallCount)
                {
                    dragIndexesArray = Combination::GetIndexes((unsigned char)drageIndexArray->GetLength(), (unsigned char)(pass - gallCount));
                }
                else
                {
                    dragIndexesArray = new  Array<Array<unsigned char>*>(1);
                }
                
                giaLen=gallIndexesArray->GetLength();
                diaLen=dragIndexesArray->GetLength();
                Array<unsigned char>* gallIndexes;
                Array<unsigned char>* dragIndexes;
                for(giIndex=0; giIndex<giaLen; giIndex++)
                {
                    
                    gallIndexes=*(*gallIndexesArray)[giIndex];
                    giLen=gallIndexes->GetLength();
                    
                    for (int n = 0; n < giLen; n++)
                    {
                        ncIndexArray[n] = *(*gallIndexArray)[*(*gallIndexes)[n]];
                    }
                    
                    if(giLen<pass)
                    {
                        for ( i = 0; i < diaLen; i++)
                        {
                            int c = gallCount;
                            dragIndexes=*(*dragIndexesArray)[i];
                            diLen=dragIndexes->GetLength();
                            for (int n = 0; n < diLen; n++)
                            {
                                ncIndexArray[c++] = *(*drageIndexArray)[*(*dragIndexes)[n]];
                            }
                            //Array.Copy(dragIndexesArray[i], 0, ncIndexArray, gallCount, dragIndexesArray[i].Length);
                            result += CalculateSubPass(ncIndexArray,pass, (*samePassModeDic[pass])->ToArray());
                        }
                    }else{
                        result += CalculateSubPass(ncIndexArray,pass, (*samePassModeDic[pass])->ToArray());
                    }
                }
                
                for( i = 0; i < giaLen; i++)
                {
                    delete *(*gallIndexesArray)[i];
                }
                delete gallIndexesArray;
                
                for( i = 0; i < diaLen; i++)
                {
                    delete *(*dragIndexesArray)[i];
                }
                delete dragIndexesArray;
            }
        }
        else
        {
            diaLen=drageIndexArray->GetLength();
            if(pass>diaLen)
            {
                continue;
            }
            Array<Array<unsigned char>*>* dragIndexesArray = Combination::GetIndexes((unsigned char)diaLen, (unsigned char)pass);
            Array<unsigned char>* dragIndexes;
            unsigned char* diArray=0;
            int* intArray=drageIndexArray->GetArray();
            diaLen=dragIndexesArray->GetLength();
            for(i=0; i<diaLen; i++)
            {
                dragIndexes=*(*dragIndexesArray)[i];
                diLen=dragIndexes->GetLength();
                diArray=dragIndexes->GetArray();
                for(int n=0; n<diLen; n++)
                {
                    ncIndexArray[n]=intArray[diArray[n]];
                }
                result += CalculateSubPass(ncIndexArray,pass, (*samePassModeDic[pass])->ToArray());
                delete dragIndexes;
            }
            delete dragIndexesArray;
            
            
        }
        delete (*samePassModeDic[pass]);
        delete[] ncIndexArray;
    }
    delete[] keys;
    return result;
}


int MLBetCountor::CalculateSubPass(int* indexArray,int indexLen, Array<PassMode*>* passModeList)
{
    Array<Array<int>*>* fieldLenArray=mlInfos->GetGameTypeOptionsLenArray();
    int* countArray = new int[indexLen];
    int i = 0;
    for ( i = 0; i < indexLen; i++)
    {
        countArray[i] = (*(*fieldLenArray)[indexArray[i]])->GetLength();
    }
    Array<Array<unsigned char>*>* typeIndexesArray= Combination::GetMultiCombineIndexes(countArray,indexLen);
    Array<unsigned char>** tiaArray=typeIndexesArray->GetArray();
    int tiaLen=typeIndexesArray->GetLength();
    int sum = 0;
    int index=0;
    PassMode** passModes=passModeList->GetArray();
    int pmLen=passModeList->GetLength();
    for(int tiaIndex=0; tiaIndex<tiaLen; tiaIndex++)
    {
        Array<unsigned char>* tiArray=tiaArray[tiaIndex];
        
        for(int pmIndex=0; pmIndex<pmLen; pmIndex++)
        {
            PassMode* passMode=passModes[pmIndex];
            Array<Array<unsigned char>*>*  array = passMode->GetIndexes();
            int arrayLen=array->GetLength();
            for ( i = 0; i <arrayLen; i++)
            {
                int temp = 1;
                int arrayInnerLen=(*(*array)[i])->GetLength();
                for (int j = 0; j < arrayInnerLen; j++)
                {
                    index=*(*(*(*array)[i]))[j];
                    temp *= *(*(*(*fieldLenArray)[indexArray[index]]))[*(*tiArray)[index]];
                }
                sum += temp;
            }
        }
        delete tiArray;
    }
    delete typeIndexesArray;
    delete countArray;
    
    return sum;
}



void MLBetCountor::FillSamePassMode(List<PassMode*>* passModeList,Dictionary<int, List<PassMode*>*>* dic)
{
    
    int pmLen=passModeList->Count();
    int pass=0;
    
    for (int i = 0; i < pmLen; i++)
    {
        pass=(*(*passModeList)[i])->GetPass();
        List<PassMode*>** pList=(*dic)[pass];
        if (pList!=0)
        {
            (*pList)->Add(*(*passModeList)[i]);
        }
        else
        {
            List<PassMode*>* newList = new List<PassMode*>();
            newList->Add(*(*passModeList)[i]);
            dic->Add(pass, newList);
        }
    }
}


