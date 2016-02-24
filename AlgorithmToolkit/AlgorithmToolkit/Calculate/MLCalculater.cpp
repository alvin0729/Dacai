#include "MLCalculater.h"

MLCalculater::MLCalculater(Array<MLAnalyser*>* fieldAnalyserArray,Array<int>* gallIndexArray,Array<int>* gallRangeArray,Array<PassMode*>* passModes)
{
    //ctor
    this->fieldAnalyserArray=fieldAnalyserArray;
    this->gallIndexArray=gallIndexArray;
    this->gallRangeArray=gallRangeArray;
    this->passModes=passModes;
    this->Init();
}

MLCalculater::~MLCalculater()
{
    //dtor
    if(mlInfos!=0)
    {
       delete mlInfos;
    }
    
    if (maxSps && maxSps->GetLength()) {
        double *array = maxSps->GetArray();
        delete [] array;
    }
    if (minSps && minSps->GetLength()) {
        double *array = minSps->GetArray();
        delete [] array;
    }
    if (feildLenArray && feildLenArray->GetLength()) {
//        for (int i = 0; i < feildLenArray->GetLength(); i++) {
//            Array<int> *p = *(*feildLenArray)[i];
//            if (p) {
//                if (p->GetLength()) {
//                    delete [] p->GetArray();
//                }
//                delete p;
//            }
//        }
        Array<int> **p = feildLenArray->GetArray();
        delete [] p;
    }
}


Int64 MLCalculater::GetBetCount()
{
    MLBetCountor mlbc(mlInfos);

	return mlbc.Calculate();
}

double MLCalculater::GetMaxBonus()
{
     MLMaxBonusCalculater mlMaxBc(mlInfos);

	 return mlMaxBc.Calculate();
}

double MLCalculater::GetMinBonus()
{
      MLMinBonusCalculater mlMinBc(mlInfos);

	 return mlMinBc.Calculate();
}

void MLCalculater::Init()
{
    this->mlInfos=0;
    feildLenArray=0;
    maxSps=0;
    minSps=0;
    hadAllArray=0;
    int len=this->fieldAnalyserArray->GetLength();
    Array<int>** flArray=new Array<int>*[len];
    double* maxs=new double[len];
    double* mins=new double[len];
    MLAnalyser* analyser=0;
    List<int> hadAllList;
    bool isAll=0;
    for(int i=0;i<len;i++)
    {
       analyser=*(*fieldAnalyserArray)[i];
       flArray[i]=analyser->GetGameTypeOptionLenArray();
       maxs[i]=analyser->GetMaxComSp();
       mins[i]=analyser->GetMinComSp();
       isAll=analyser->IsHadAllOption();
       if(isAll)
       {
          hadAllList.Add(i);
       }
    }


    if(hadAllList.Count()>0)
    {
        hadAllArray=hadAllList.ToArray();
    }

    feildLenArray=new Array<Array<int>*>();
    feildLenArray->Set(flArray,len);

    maxSps=new Array<double>();
    maxSps->Set(maxs,len);

    minSps=new Array<double>();
    minSps->Set(mins,len);

    this->mlInfos=new MLOptions(feildLenArray,hadAllArray,this->gallIndexArray,this->gallRangeArray,this->passModes,maxSps,minSps);

}
