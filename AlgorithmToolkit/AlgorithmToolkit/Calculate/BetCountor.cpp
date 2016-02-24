 // BetCountor.cpp: implementation of the BetCountor class.
//
//////////////////////////////////////////////////////////////////////

#include "BetCountor.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

BetCountor::BetCountor(PassMode* mode,Array<int>*  gallOptionLenArray, Array<int>*  dragOptionLenArray, Array<int>*  gallRangeArray)
{
    this->gallOptionLenArray=gallOptionLenArray;
    this->dragOptionLenArray=dragOptionLenArray;
    this->gallRangeArray=gallRangeArray;
    this->mode=mode;
}

BetCountor::~BetCountor()
{
    
}

Int64 BetCountor::Calculate()
{
    
    Int64 sum = 0;
    
    int* gallFieldsLenArray =0;
    unsigned char* gallFieldsLenCountArray = 0;
    
    int* dragFieldsLenArray = 0;
    unsigned char* dragFieldsLenCountArray = 0;
    int pass=mode->GetPass();
    int* fieldsLenArray = new int[pass];
    
    
    int grLen=0;
    if(gallRangeArray!=0)
    {
        grLen=gallRangeArray->GetLength();
    }
    int dragLen=0;
    if(dragOptionLenArray!=0)
    {
        dragLen=this->dragOptionLenArray->GetLength();
    }
    int gallLen=0;
    if(gallOptionLenArray!=0)
    {
        gallLen=this->gallOptionLenArray->GetLength();
    }
    
    if(gallLen>0&&grLen==0)
    {
        //含胆 但没有胆的范围返回计算错误
        return -1;
    }
    
    int dragFLALen=0;
    
    if(dragLen>0)
    {
        dragFLALen=this->GetSameCount(dragOptionLenArray,dragFieldsLenArray,dragFieldsLenCountArray);
    }
    int gallFLALen=0;
    
    if(gallLen>0)
    {
        gallFLALen=this->GetSameCount(gallOptionLenArray,gallFieldsLenArray,gallFieldsLenCountArray);
    }
    int i = 0;
    int index=0;
    int gallRange=0;
    int fl = 0;
    if(grLen>0)
    {
        for ( ; i < grLen; i++)
        {
            gallRange=*(*gallRangeArray)[i];
            int fetchDragLen=mode->GetPass()-gallRange;
            if (fetchDragLen< 0)
            {
                continue;
            }
            Fetcher fetcherGall(gallFieldsLenCountArray,gallFLALen,gallRange);
            Fetcher fetcherDrag(dragFieldsLenCountArray, dragFLALen,fetchDragLen);
            List<unsigned char *> gallExpList = fetcherGall.Calculate();
            List<unsigned char *> dragExpList = fetcherDrag.Calculate();
            
            int gallELCount=gallExpList.Count();
            int dragELCount=dragExpList.Count();
            unsigned char* gallExpArray=0;
            unsigned char* dragExpArray=0;
            for (int n = 0; n < gallELCount; n++)
            {
                fl = 0;
                Int64 gallRepeat = 1;
                gallExpArray=*gallExpList[n];
                for (int p = 0; p < gallFLALen; p++)
                {
                    
                    if (gallExpArray[p] == 0)
                    {
                        continue;
                    }
                    gallRepeat *= Combination::GetInt64(gallFieldsLenCountArray[p], gallExpArray[p]);
                    for (int r = 0; r < gallExpArray[p]; r++)
                    {
                        fieldsLenArray[fl++] = gallFieldsLenArray[p];
                    }
                }
                if(gallRange<pass)
                {
                    for (int m = 0; m < dragELCount; m++)
                    {
                        fl = gallRange;
                        Int64 dragRepeat = 1;
						dragExpArray=*dragExpList[m];
                        for (int p = 0; p < dragFLALen; p++)
                        {
                            if (dragExpArray[p] == 0)
                            {
                                continue;
                            }
                            dragRepeat *= Combination::GetInt64(dragFieldsLenCountArray[p], dragExpArray[p]);
                            for (int r = 0; r < dragExpArray[p]; r++)
                            {
                                fieldsLenArray[fl++] = dragFieldsLenArray[p];
                            }
                        }
                        
                        Int64 all = gallRepeat * dragRepeat;
                        Array<Array<unsigned char>*>* indexesArray = mode->GetIndexes();
                        Int64 subSum = 0;
						int modeIndexesArrayLength=indexesArray->GetLength();
						Array<unsigned char>* modeInnerIndexes=0;
						int modeInnerIndexesLength=0;
                        for (int betIndex = 0; betIndex < modeIndexesArrayLength; betIndex++)
                        {
                            int c = 1;
							modeInnerIndexes=*(*indexesArray)[betIndex];
                            modeInnerIndexesLength=modeInnerIndexes->GetLength();
                            for (int betLenIndex = 0; betLenIndex < modeInnerIndexesLength; betLenIndex++)
                            {
                                c *= fieldsLenArray[*(*modeInnerIndexes)[betLenIndex]];
                            }
                            subSum += c;
                        }
                        sum += subSum * all;
                    }
                }
                else{
                    Int64 all = gallRepeat ;
                    Array<Array<unsigned char>*>* indexesArray = mode->GetIndexes();
                    Int64 subSum = 0;
                    int modeIndexesArrayLength=indexesArray->GetLength();
                    Array<unsigned char>* modeInnerIndexes=0;
                    int modeInnerIndexesLength=0;
                    for (int betIndex = 0; betIndex < modeIndexesArrayLength; betIndex++)
                    {
                        int c = 1;
                        modeInnerIndexes=*(*indexesArray)[betIndex];
                        modeInnerIndexesLength=modeInnerIndexes->GetLength();
                        for (int betLenIndex = 0; betLenIndex < modeInnerIndexesLength; betLenIndex++)
                        {
                            c *= fieldsLenArray[*(*modeInnerIndexes)[betLenIndex]];
                        }
                        subSum += c;
                    }
                    sum += subSum * all;
                }
            }
            
            for (index = 0; index < gallELCount; index++)
            {
                delete[] *gallExpList[index];
            }
            
            
            for (index = 0; index < dragELCount; index++)
            {
                delete[] *dragExpList[index];
            }
            
        }
    }else
    {
        int pass=mode->GetPass();
        Fetcher fetcherDrag(dragFieldsLenCountArray, dragFLALen,pass);
        List<unsigned char *> dragExpList = fetcherDrag.Calculate();
        int dragELCount=dragExpList.Count();
        unsigned char* dragExpArray=0;
        
        for (int m = 0; m < dragELCount; m++)
        {
            fl = 0;
            Int64 dragRepeat = 1;
            dragExpArray=*dragExpList[m];
            for (int p = 0; p < dragFLALen; p++)
            {
                if (dragExpArray[p] == 0)
                {
                    continue;
                }
                dragRepeat *= Combination::GetInt64(dragFieldsLenCountArray[p], dragExpArray[p]);
                for (int r = 0; r < dragExpArray[p]; r++)
                {
                    fieldsLenArray[fl++] = dragFieldsLenArray[p];
                }
            }
            
            Int64 all = dragRepeat;
            Array<Array<unsigned char>*>* indexesArray = mode->GetIndexes();
            Int64 subSum = 0;
            int modeIndexesArrayLength=indexesArray->GetLength();
            Array<unsigned char>* modeInnerIndexes=0;
            int modeInnerIndexesLength=0;
            for (int betIndex = 0; betIndex < modeIndexesArrayLength; betIndex++)
            {
                int c = 1;
                modeInnerIndexes=*(*indexesArray)[betIndex];
                modeInnerIndexesLength=modeInnerIndexes->GetLength();
                for (int betLenIndex = 0; betLenIndex < modeInnerIndexesLength; betLenIndex++)
                {
                    c *= fieldsLenArray[*(*modeInnerIndexes)[betLenIndex]];
                }
                subSum += c;
            }
            sum += subSum * all;
        }
        
        for (index = 0; index < dragELCount; index++)
        {
            delete[] *dragExpList[index];
        }
    }
    
    if(gallFieldsLenArray !=0)
    {
        delete[] gallFieldsLenArray;
    }
    if(gallFieldsLenCountArray != 0)
    {
        delete[] gallFieldsLenCountArray;
    }
    
    if(dragFieldsLenArray != 0)
    {
        delete[] dragFieldsLenArray;
    }
    
    if(dragFieldsLenCountArray != 0)
    {
        delete[] dragFieldsLenCountArray;
    }
    
    delete[] fieldsLenArray;
    
    return sum;
}

int BetCountor::GetSameCount(Array<int>* optionLenArray,int* &sameLenArray,unsigned char* &sameCountArray)
{
	List<int> distinctOptionLenList;
	List<unsigned char> dolCountList;
	int reLen=0;
	int dolListCount=0;
	bool isAdd=false;
	int olLen=optionLenArray->GetLength();
    for(int i=0;i<olLen;i++)
    {
        isAdd=false;
        dolListCount=distinctOptionLenList.Count();
        for(int j=0;j<dolListCount;j++)
        {
            if((*(*optionLenArray)[i])==(*distinctOptionLenList[j]))
            {
                (*dolCountList[j])++;
                isAdd=true;
                break;
            }
        }
        if(!isAdd)
        {
            distinctOptionLenList.Add(*(*optionLenArray)[i]);
            dolCountList.Add(1);
            reLen++;
        }
    }
    sameLenArray=new int[reLen];
    sameCountArray=new unsigned char[reLen];
    distinctOptionLenList.ToArray(sameLenArray,reLen);
    dolCountList.ToArray(sameCountArray,reLen);
    return reLen;
}

Int64 BetCountor::Calculate(Array<PassMode*>* passModes, Array<int>*  gallOptionLenArray, Array<int>*  dragOptionLenArray,Array<int>*  gallRangeArray)
{
	if(passModes==0)
	{
        return 0;
	}
	int i=0;
	Int64 result=0;
	Int64 temp=0;
	int modeLen=passModes->GetLength();
	for(;i<modeLen;i++)
	{
	    BetCountor bc(*(*passModes)[i],gallOptionLenArray,dragOptionLenArray,gallRangeArray);
		temp=bc.Calculate();
		result+=temp;
	}
    return result;
}
